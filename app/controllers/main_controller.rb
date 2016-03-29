class MainController < ApplicationController
	def index
		@issues=DataIssue.all
		@persons=DataPerson.all
        @details=DataDetail.order(:count).reverse.first(10)
        if user_signed_in?
            logger.debug "!!!!! Has user login !!!!!"
            if current_user.email == "darkgrouptw@gmail.com" || current_user.email == "b10215014@mail.ntust.edu.tw"
                logger.debug "Is Admin"
                #logger.debug 
                User.where(email: current_user.email)[0].update(high_power: true)
            else
                User.where(email: current_user.email)[0].update(high_power: false)
            end
        end
	end
end
