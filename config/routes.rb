Rails.application.routes.draw do 
    root    "main#index"
    
    
    
    # 登入頁面 ＆ 登出
    get     "User/Login"        =>  "user/login#login",         :as =>  "login"
    delete  "User/Logout"       =>  "user/login#logout",        :as =>  "logout"
    post    "User/VerifyAccout" =>  "user/login#verify",        :as =>  "login_verify"
    
    # 註冊頁面
    get     "RegisterEmail"     =>  "user/register#index",      :as =>  "register_email"
    post    "RegisterSendEmail" =>  "user/register#sendEmail",  :as =>  "register_send_email"
    get     "WaitForVerify"     =>  "user/register#wait",       :as =>  "wait_for_verify"
    get     "VerifyEmail"       =>  "user/register#verify"
    get     "Register/form"     =>  "user/register#form",       :as =>  "register_form"
    post    "Register/success"  =>  "user/register#success",    :as =>  "register_success"
    
    # issue page
    get     "Issuelist/all"     =>  "issuelist#all",     :as =>  "issuelist_all"
    get     "Issuelist/:id"     =>  "issuelist#index",   :as =>  "issuelist_index"
    # people page
    get     "Peoplelist/all"    =>  "peoplelist#all",   :as =>  "peoplelist_all"
    get     "Peoplelist/:id"    =>  "peoplelist#index", :as =>  "peoplelist_index"
    
end
