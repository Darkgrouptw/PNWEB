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
	get     "Issuelist/all"     =>  "issuelist#all",            :as =>  "issuelist_all"
	get     "Issuelist/add"     =>  "issuelist#add",            :as =>  "issuelist_add"
	post    "Issuelist/new"     =>  "issuelist#new",            :as =>  "issuelist_new"
	get     "Issuelist/edit/:id"    =>  "issuelist#edit",       :as =>  "issuelist_edit"
	post    "Issuelist/update"  =>  "issuelist#update",         :as =>  "issuelist_update"
	get		"Issuelist/candidate"	=>	"issuelist#candidate",	:as =>	"issuelist_candidate"
	post 	"Issuelist/thumb_up"	=>	"issuelist#thumb_up",	:as => 	"issuelist_thumb_up"
	post 	"Issuelist/upgrade"	=>	"issuelist#upgrade",	    :as =>	"issuelist_upgrade"
	get     "Issuelist/:id"     =>  "issuelist#index",          :as =>  "issuelist_index"

	# people page
	get     "Peoplelist/all"    =>  "peoplelist#all",           :as =>  "peoplelist_all"
	get     "Peoplelist/add"    =>  "peoplelist#add",           :as =>  "peoplelist_add"
	post    "Peoplelist/new"    =>  "peoplelist#new",           :as =>  "peoplelist_new"
	get     "Peoplelist/edit/:id"   =>  "peoplelist#edit",      :as =>  "peoplelist_edit"
	post    "Peoplelist/update" =>  "peoplelist#update",        :as =>  "peoplelist_update"
	get     "Peoplelist/:id"    =>  "peoplelist#index",         :as =>  "peoplelist_index"

	# detail page
	get     "Detaillist/add/:id"    =>  "detaillist#add",       :as =>  "detaillist_add"
	post    "Detaillist/new"    =>  "detaillist#new",           :as =>  "detaillist_new"
	get     "Detaillist/edit/:id"   =>  "detaillist#edit",      :as =>  "detaillist_edit"
	post    "Detaillist/update" =>  "detaillist#update",        :as =>  "detaillist_update" 
	post    "Detaillist/like"   =>  "detaillist#like",          :as =>  "detaillist_like"
	post    "Detaillist/dislike"=>  "detaillist#dislike",       :as =>  "detaillist_dislike"
	get     "Detaillist/:id"    =>  "detaillist#index",         :as =>  "detaillist_index"

	# detail comment page
	post 	"Comment/new"		=>	"detaillist#comment_new",	:as =>	"detaillist_comment_new"

	# poster page
	post 	"User/upgrade"		=>	"user/userlist#upgrade",:as =>	"userlist_upgrade"
	post 	"User/downgrade"	=>	"user/userlist#downgrade",	:as =>	"userlist_downgrade"
	get		"User/power/edit/:id"	=>	"user/userlist#power_edit",	:as =>	"userlist_power_edit"
	post 	"User/power/update"	=>	"user/userlist#power_update",	:as =>	"userlist_power_update"
	get		"User/all"			=>	"user/userlist#all",	:as =>	"userlist_all"
	get     "User/:id"          =>  "user/userlist#index",  :as =>  "userlist_index"

	# report
	get     "Reportlist/all"    =>  "reportlist#all",           :as =>  "reportlist_all"
	post    "Reportlist/new"    =>  "reportlist#new",           :as =>  "reportlist_new"
	get     "Reportlist/add/:id"    =>  "reportlist#add",       :as =>  "reportlist_add"
	post    "Reportlist/reject" =>  "reportlist#reject",        :as =>  "reportlist_reject"
	post    "Reportlist/accept" =>  "reportlist#accept",        :as =>  "reportlist_accept"
	get     "Reportlist/:id"    =>  "reportlist#index",         :as =>  "reportlist_index"

    
    get     "EditingTree"       =>  "main#editing"
    

	# notify
	post 	"Notify"            =>	"main#notify",	    :as =>	"notify"
	# openThread
	post 	"Open_thread"		=>	"main#open_thread",	:as =>	"open_thread"
    
	# peopleName & issueName 要拿 params 用的
	get 	"PeopleName"        =>	"main#peopleName",	:as =>	"peopleName"
	get		"IssueName"			=>	"main#issueName",	:as =>	"issueName"
end
