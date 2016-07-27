class MainController < ApplicationController
    
    def index
        # 刪除 email 得 Session
        clearEmailSession

        @issues=DataIssue.where(trunk_id: -1).order(:created_at).reverse.first(10)
        @details=DataDetail.all.order(:count).reverse.first(10)
        person = []
        @details.each do |detail|
            person.push([detail.people_id])
        end
        @persons=DataPerson.where(id: person)
    end
end
