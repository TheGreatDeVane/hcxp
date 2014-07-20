class SessionsController < Devise::SessionsController

  class NotEnoughParams < ArgumentError; end

  def new
    super
  end

  def create
    # raise NotEnoughParams if !params[:user][:username].present? || !params[:user][:password].present?

    if params[:commit_fhcpl].present?
      sign_in_fhcpl
    elsif params[:commit_hcxp].present?
      sign_in_hcxp
    else
      throw 'error'
    end

  rescue NotEnoughParams
    flash.now[:notice] = 'Please provide username and password!'
    render action: :new

  rescue Khcpl::InvalidCredentials => e
    flash[:error] = e.message
    render action: :new
  end

  private

    def sign_in_hcxp
      user = User.find_by_username(params[:user][:username])

      if user && user.valid_password?(params[:user][:password])
        flash[:success] = t('devise.sessions.signed_in')
        sign_in_and_redirect user
      else
        flash[:error] = t('devise.failure.invalid')
        render action: :new
      end
    end

    def sign_in_fhcpl
      fhcpl     = Khcpl::Fhcpl.new(params[:user][:username], params[:user][:password])
      user_data = fhcpl.get_profile_info
      service   = Service.find_by(uid: user_data[:user_id], provider: user_data[:provider])

      if service
        flash[:success] = t('devise.sessions.signed_in_with_fhcpl')
        sign_in_and_redirect service.user

      else
        user = User.create!(
          email:    user_data[:user_email],
          username: user_data[:user_name],
          password: SecureRandom.hex(10)
        )
        user.services.create(
          uid:      user_data[:user_id],
          provider: user_data[:provider],
          uname:    user_data[:user_name],
          uemail:   user_data[:user_email]
        )

        flash[:success] = 'New account has been created using forum.hard-core.pl data. You\'re now signed in.'
        sign_in_and_redirect user
      end
    end

end