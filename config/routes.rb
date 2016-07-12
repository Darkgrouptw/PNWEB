Rails.application.routes.draw do 
    root    "main#index"
    
    # 註冊頁面
    get     "RegisterEmail"     =>  "user/register#index",      :as =>  "register_email"
    post    "RegisterSendEmail" =>  "user/register#sendEmail",  :as =>  "register_send_email"
    get     "WaitForVerify"     =>  "user/register#wait",       :as =>  "wait_for_verify"
    get     "VerifyEmail"       =>  "user/register#verify"
    post    "Register/form"     =>  "user/register#form",       :as =>  "register_form"
end
