ad_page_contract {
    Present form to begin adding a question to a survey.
    Lets user enter the question and select a presentation type.

    @param section_id    integer designating survey we're adding question to
    @param after        optinal integer denoting position of question within survey

    @author  jsc@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    February 9, 2000
    @cvs-id $Id$
} {
    section_id:integer
    {after:integer ""}
    
}

set package_id [ad_conn package_id]
set user_id [ad_get_user_id]
ad_require_permission $package_id survey_create_question

get_survey_info -section_id $section_id

ad_form -name create_question -action question-add-2  -export { after } -form {
    question_id:key
    {section_id:text(hidden) {value $section_id}}
    {question_text:text(textarea) {label "Question"}  {html {rows 5 cols 70}}}   
}

ad_form -extend -name create_question -form {
     {presentation_type:text(select)
	 {label "Presentation Type"}
	 {options {{ "One Line Answer (Text Field)" "textbox" }
	           { "Essay Answer (Text Area)" "textarea" }
        	     { "Multiple Choice (Drop Down, single answer allowed)" "select" }
        	     { "Multiple Choice (Radio Buttons, single answer allowed)" "radio" }
		     { "Multiple Choice (Checkbox, multiple answers allowed)" "checkbox" }
		     { "Date" "date" }
		     { "File Attachment" "upload_file" } } } }
}	    
		
    

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
set context_bar [ad_context_bar [list "one?[export_url_vars survey_id]" $survey_info(name)] "Add A Question"]

if {[ad_parameter allow_question_deactivation_p] == 1} {
    ad_form -extend -name create_question -form {
        {active:text(radio)     {label "Active?"} {options {{Yes t} {No f}}} {value t}}
    } 
} else {
    ad_form -extend -name create_question -form {
        {active:text(hidden) {value t}}
    }
}
ad_form -extend -name create_question -form {
    {required:text(radio)     {label "Required?"} {options {{Yes t} {No f}}} {value t}}
}
    
ad_return_template




