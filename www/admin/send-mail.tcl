ad_page_contract {

    this page offers options for sending email regarding
    a survey to various groups

    @param survey_id
    
    @author dave@thedesignexperience.org
    @date   July 29, 2002
    @cvs-id $Id:
} {
  survey_id:integer,notnull
  {package_id:integer 0}
  {to "responded"}  
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set sender_id [ad_conn user_id]

ad_require_permission $survey_id survey_admin_survey

get_survey_info -survey_id $survey_id
set survey_name $survey_info(name)
db_1row select_sender_info {}
set dotlrn_installed_p [apm_package_installed_p dotlrn]
if {$dotlrn_installed_p} {
    set rel_type "dotlrn_member_rel"
    set community_id [dotlrn_community::get_community_id]
    set segment_id [db_string select_rel_segment_id {}]
    set community_name [dotlrn_community::get_community_name $community_id]
    set community_url "[ad_parameter -package_id [ad_acs_kernel_id] SystemURL][dotlrn_community::get_community_url $community_id]"

    set n_responses [db_string n_responses {}]
    if {$n_responses > 0} {
	ad_form -name send-mail -form {
	    {to:text(radio) {options {
		{"Everyone eligible to take this survey" "all"}
		{"Everyone who has already taken this survey" "responded"}
		{"Everyone who has not yet taken this survey" "not_responded"}}}
		{label "Send mail to"}
		{value $to}
	    }
	}
    } else {
	ad_form -name send-mail -form {
	    {to:text(radio) {options {
		{"Everyone eligible to take this survey" "all"}
		{"Everyone who has not yet taken this survey" "not_responded"}}}
		{label "Send mail to"}
		{value $to}
	    }
	}
    }
} else {
    ad_form -name send-mail -form {
	{to:text(radio) {options {
	    {"Everyone who has already taken this survey" "all"}}} 
	    {value "all"}
	    {label "Send mail to"}
	}
    }
}

ad_form -extend -name send-mail -form {
    {subject:text(text) {value $survey_name} {label "Message Subject"} {html {size 50}}}
    {message:text(textarea) {label "Enter Message"} {html {rows 15 cols 60}}}
    {survey_id:text(hidden) {value $survey_id}}
    {package_id:text(hidden) {value $package_id}}
} -on_submit {

set query ""

if {$dotlrn_installed_p} {
    switch $to {
	    all {
		    set query [db_map dotlrn_all]
		}
	    
	    responded {
		    set query [db_map dotlrn_responded]
		}
	   
	    not_responded {
		set query [db_map dotlrn_not_responded]
	    }
    }
} else {
    set query [db_map responded]
}

ns_log notice "DAVE-SURVEY: $query"
	bulk_mail::new \
	    -package_id $package_id \
	    -from_addr $sender_email \
	    -subject $subject \
            -message $message \
            -query $query
    ad_returnredirect "one?survey_id=$survey_id"
    ad_script_abort
}

set context_bar [ad_context_bar "Send Mail"]
ad_return_template

