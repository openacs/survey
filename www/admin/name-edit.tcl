ad_page_contract {

    Edit the name of the survey

    @param  section_id  integer denoting survey whose description we're changing

    @author Jin Choi (jsc@arsdigita.com) 
    @author nstrug@arsdigita.com
    @date   February 16, 2000
    @cvs-id $Id$
} {

    survey_id:integer
    {name ""}
}

get_survey_info -survey_id $survey_id
set survey_name $survey_info(name)
set survey_description $survey_info(description)

ad_require_permission $survey_id survey_modify_survey

ad_form -name edit-name -form {
    survey_id:key
    {name:text(text) {label "[_ survey.Survey_Name_1]"} {html {size 80}}
	{value $survey_name}}
	{description:text(textarea) {label "[_ survey.Description_1]"} 
	{html {rows 10 cols 65}}
        {value $survey_description}}
} -validate {
    {name {[string length $name] <= 4000}
    "[_ survey.lt_Survey_Name_must_be_l]"
    }
} -edit_request {
    set name $survey_name
} -edit_data {
    db_dml survey_update ""
    ad_returnredirect "one?[export_vars survey_id]"
    ad_script_abort
}

set context_bar [ad_context_bar "[_ survey.Edit_Name]"]

ad_return_template


