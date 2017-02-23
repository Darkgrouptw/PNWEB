Rails.application.routes.draw do 

	root    "main#index"
	post 	"read"			=>	"main#writeDataFromFile",	:as =>	"read"
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
	post 	"Issuelist/hide"	=>	"issuelist#hide",			:as =>	"issuelist_hide"
	get     "Issuelist/:id"     =>  "issuelist#index",          :as =>  "issuelist_index"

	# people page
	get		"peoplelist/manager"=>	"peoplelist#manager",		:as =>	"peoplelist_manager"
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
	post 	"Detaillist/groupeDislike"	=>	"detaillist#groupeDislike",	:as => "detaillist_groupeDislike"
	post 	"Detaillist/delete"	=>	"detaillist#delete",		:as =>	"detaillist_delete"
	get     "Detaillist/:id"    =>  "detaillist#index",         :as =>  "detaillist_index"

	# detail comment page
	post 	"Comment/new"		=>	"detaillist#comment_new",	:as =>	"detaillist_comment_new"

	#media page
	post 	"Media/new"			=>	"media#new",				:as =>	"media_new"
	post 	"Media/hide"		=>	"media#hide",				:as =>	"media_hide"
	get		"Media/all"			=>	"media#all",				:as =>	"media_all"
	get  	"Media/:id"			=>	"media#index",				:as =>	"media_index"
	# poster page
	post 	"User/disable"		=>	"user/userlist#disable",	:as =>	"userlist_disable"
	post 	"User/upgrade"		=>	"user/userlist#upgrade",:as =>	"userlist_upgrade"
	post 	"User/downgrade"	=>	"user/userlist#downgrade",	:as =>	"userlist_downgrade"
	get		"User/power/edit/:id"	=>	"user/userlist#power_edit",	:as =>	"userlist_power_edit"
	post 	"User/power/update"	=>	"user/userlist#power_update",	:as =>	"userlist_power_update"
	get		"User/all"			=>	"user/userlist#all",	:as =>	"userlist_all"
	get		"User/edit/:id"		=>	"user/userlist#edit",	:as =>	"userlist_edit"
	get     "User/:id"          =>  "user/userlist#index",  :as =>  "userlist_index"

	# report
	get     "Reportlist/all"    =>  "reportlist#all",           :as =>  "reportlist_all"
	post    "Reportlist/new"    =>  "reportlist#new",           :as =>  "reportlist_new"
	get     "Reportlist/add/:id"    =>  "reportlist#add",       :as =>  "reportlist_add"
	post    "Reportlist/reject" =>  "reportlist#reject",        :as =>  "reportlist_reject"
	post    "Reportlist/accept" =>  "reportlist#accept",        :as =>  "reportlist_accept"
	get     "Reportlist/:id"    =>  "reportlist#index",         :as =>  "reportlist_index"

    # 給編輯數使用
    get     "TreeIndex"         =>  "main#treeindex",			:as =>	"treeindex"
    get     "TreeCanvas"        =>  "main#treecanvas"
    get     "TreeThumbUp"       =>  "main#tree_thumb_up"
    get     "TreeJson"          =>  "main#treejson",			:as =>  "treejson"
    get     "TreeCheck"         =>  "main#tree_check"
    get     "TreeAddRoot"       =>  "main#root_add"
    post    "TreeSaveAllNode"   =>  "main#tree_save_all_node"

	# notify
	post 	"Notify"            =>	"main#notify",	    :as =>	"notify"
	# openThread
	post 	"Open_thread"		=>	"main#open_thread",	:as =>	"open_thread"
    
	# peopleName & issueName 要拿 params 用的
	get 	"PeopleName"        =>	"main#peopleName",	:as =>	"peopleName"
	get		"IssueName"			=>	"main#issueName",	:as =>	"issueName"
	get		"IssueID"			=>	"main#issueID",	    :as =>	"issueID"
	get		"MediaName"			=>	"main#mediaName",	:as =>	"mediaName"
	get		"tree_check"		=>	"main#tree_check",	:as =>	"tree_check"
	get		"ipTest"			=>	"main#ipTest",		:as =>	"ipTest"

	#Only for Manager
	post	"killIssue"			=>	"main#killIssue",	:as =>	"killIssue"
	post	"BackUpDetail"		=>	"main#backUpDetail",:as =>	"backUpDetail"
end
