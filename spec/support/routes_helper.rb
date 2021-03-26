module RoutesHelper
  ActionController::TestCase::Behavior.module_eval do
    alias_method :process_old, :process

    def process(action, *args)
      if params = args.first[:params]
        params["locale"] = I18n.default_locale
      end
      process_old(action, *args)
    end
  end
end
