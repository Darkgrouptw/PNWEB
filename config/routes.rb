Rails.application.routes.draw do 
    root    "main#index"
    
    
    
    # 登入頁面 ＆ 登出
    get     "User/Login"        =>  "user/login#login",         :as =>  "login"
    delete  "User/Logout"       =>  "user/login#logout",        :as =>  "logout"
    
    # 註冊頁面
    get     "RegisterEmail"     =>  "user/register#index",      :as =>  "register_email"
    post    "RegisterSendEmail" =>  "user/register#sendEmail",  :as =>  "register_send_email"
    get     "WaitForVerify"     =>  "user/register#wait",       :as =>  "wait_for_verify"
    get     "VerifyEmail"       =>  "user/register#verify"
    get     "Register/form"     =>  "user/register#form",       :as =>  "register_form"
    post    "Register/success"  =>  "user/register#success",    :as =>  "register_success"
    
end
