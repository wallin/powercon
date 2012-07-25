Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '251771341576459', 'ac8ce172da5275276a009b0adb893d0f'
end
