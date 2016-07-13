class MainController < ApplicationController
    
    def index
        # 刪除 email 得 Session
        clearEmailSession
    end
end
