class SessionsController < Devise::SessionsController

  class NotEnoughParams < ArgumentError; end

  def new
    super
  end

  def create
    raise NotEnoughParams if !params[:user][:username].present? || !params[:user][:password].present?

    user_data = Khcpl::Fhcpl.get_profile_info(params[:user][:username], params[:user][:password])
    service   = Service.find_by(uid: user_data[:user_id], provider: user_data[:provider])

    if service
      flash.now[:error] = 'Signed in successfully using forum.hard-core.pl account.'
      sign_in_and_redirect service.user
    else
      user = User.create(email: user_data[:user_email], username: user_data[:user_name], password: SecureRandom.hex(10))
      user.services.create(uid: user_data[:user_id], provider: user_data[:provider], uname: user_data[:user_name], uemail: user_data[:user_email])
      
      flash.now[:error] = 'New account has been created using forum.hard-core.pl data. You\'re now signed in.'
      sign_in_and_redirect user
    end

  rescue NotEnoughParams
    flash.now[:notice] = 'Please provide username and password!'
    render action: :new

  rescue Khcpl::InvalidCredentials => e
    flash.now[:notice] = e.message
    render action: :new
  end

end