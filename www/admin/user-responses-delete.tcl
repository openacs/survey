ad_page_contract {

    This page allows the admin to delete survey and all responses.

    @param survey_id

    @author dave@thedesignexperience.org
    @date   August 7, 2002
    @cvs-id $Id$
} {
    survey_id:integer
    user_id:integer
}

set package_id [ad_conn package_id]
ad_require_permission $package_id survey_admin_survey

db_multirow responses get_response_info {}

set response_count [template::multirow size responses]
ad_form -name confirm_delete -form {
    {survey_id:text(hidden) {value $survey_id}}
    {user_id:text(hidden) {value $user_id}}
    {warning:text(inform) {label "Warning:"} {value "This will remove $response_count responses"}}
    {confirmation:text(radio) {label " "}
	{options
	    {{"Continue with Delete" t }
	     {"Cancel and return to survey responses" f }}	}
	    {value f}
    }

} -on_submit {
    if {$confirmation} {
	template::multirow foreach responses {
	    if {[empty_string_p $initial_response_id]} {
		db_exec_plsql delete_response {}
	    }
	}
    } 
    ad_returnredirect "one-respondent?[export_vars {survey_id user_id}]"
    ad_script_abort
}

set context_bar [ad_context_bar "Delete Response"]