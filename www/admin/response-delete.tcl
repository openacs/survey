ad_page_contract {

    This page allows the admin to delete survey and all responses.

    @param survey_id

    @author dave@thedesignexperience.org
    @date   August 7, 2002
    @cvs-id $Id$
} {
   response_id:integer,optional
}

set package_id [ad_conn package_id]
ad_require_permission $package_id survey_admin_survey

db_1row get_response_info {}

ad_form -name confirm_delete -form {
    {response_id:text(hidden) {value $response_id}}
    {survey_id:text(hidden) {value $survey_id}}
    {user_id:text(hidden) {value $user_id}}
    {warning:text(inform) {value "Completely delete ${user_name}'s response from $response_date? (Note: This can not be undone.)"}
    {label "Warning!"}}
    {confirmation:text(radio) {label " "}
	{options
	    {{"Continue with Delete" t }
	     {"Cancel and return to survey responses" f }}	}
	    {value f}
    }

} -on_submit {
    if {$confirmation} {
	db_exec_plsql delete_response {}
    } 
    ad_returnredirect "one-respondent?[export_vars {survey_id user_id}]"
}

set context_bar [ad_context_bar "Delete Response"]