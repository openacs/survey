ad_page_contract {
    Copy a survey
    @author  dave@thedesignexperience.org
    @date    August 3, 2002
    @cvs-id $Id:
} {
    survey_id:integer,notnull
    name:optional
    new_survey_id:optional
}

set package_id [ad_conn package_id]
set user_id [ad_get_user_id]

ad_require_permission $package_id survey_create_question

db_1row get_survey_info {}
set title_name $name
set name "Copy of $name"

ad_form -name copy_survey -form {
    new_survey_id:key
    {message:text(inform) {value "Copying a survey will create a new survey with copies of all the questions.<br /> None of the response data will be duplicated."}} 
    {name:text(text) {label Name} {html {size 60}} {value $name}}
    {survey_id:text(hidden) {value $survey_id}}
    
} -on_submit {
    set new_survey_id [survey_copy -survey_id $survey_id -new_name $name]

set survey_id $new_survey_id

ad_returnredirect "one?[export_vars survey_id]"
}


set context_bar [ad_context_bar "Copy $title_name"]
ad_return_template