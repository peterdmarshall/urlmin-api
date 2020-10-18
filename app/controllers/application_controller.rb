class ApplicationController < ActionController::API

    def home
        render html: "Api for urlmin.ca", status: :ok
        return
    end
end
