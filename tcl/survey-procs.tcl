# /tcl/survey-procs.tcl

ad_library {

  Support procs for simple survey module, most important being
  survey_question_display which generates a question widget based
  on data retrieved from database.

  @author philg@mit.edu on
  @author teadams@mit.edu
  @author nstrug@arsdigita.com
  @date   February 9, 2000
  @cvs-id survey-simple-defs.tcl,v 1.29.2.5 2000/07/19 20:11:24 seb Exp

}

ad_proc -public get_survey_info { 
    {-survey_id ""} 
    {-section_id ""} 
} {
    creates a tcl array variable named "survey_info" in the caller's environment,
    which contains key/value pairs for all properties of the requested survey.

    If survey_id is passed in, and it's a single-section survey, the 
    section_id will also be looked up and returned in the survey_info array.

    @author luke@museatech.net
    @date 2002-07-24
} {
    upvar survey_info survey_info

    if {[empty_string_p $survey_id]} {
	db_1row lookup_survey_id ""
    }

    db_1row get_info_by_survey_id "" -column_array survey_info

    # If it's a single-section survey, look up the section_id
    if {[empty_string_p $section_id] && $survey_info(single_section_p) == "t"} {
	db_1row lookup_single_section_id ""
	set survey_info(section_id) $section_id
    }

    # some useful stats about the survey, dotLRN specific for sloanspace
    if {[apm_package_installed_p dotlrn]} {
	set community_id [dotlrn_community::get_community_id_from_url]
	set survey_info(eligible) [db_string n_eligible {}]
	set survey_info(completed) [db_string n_completed {}]
	set survey_info(not_completed) [expr {$survey_info(eligible) - $survey_info(completed)}]
    }
}


ad_proc -public survey_question_display { 
    question_id 
    {response_id ""} 
} {Returns a string of HTML to display for a question, suitable for embedding in a form. The form variable is of the form \"response_to_question.\$question_id} {

    if {![empty_string_p $response_id]} {
	set edit_previous_response_p "t"
    } else {
	set edit_previous_response_p "f"
    }

    set element_name "response_to_question.$question_id"

    db_1row survey_question_properties ""
    if {$required_p == "t"} {
	set html "<span style=\"color: #f00;\">*</span>"
    } else {
	set html "&nbsp;"
    }

    append html $question_text
    if { $presentation_alignment == "below" } {
	append html "<br />"
    } else {
	append html " "
    }

    set user_value ""

    if {$edit_previous_response_p == "t"} {
 	set user_id [ad_get_user_id]

	set count 0
	db_foreach prev_response_query {} {
	    incr count
	    
	    if {$presentation_type == "checkbox"} {
		set selected_choices($choice_id) "t"
	    }
	} if_no_rows {
	    set choice_id 0
	    set boolean_answer ""
	    set clob_answer ""
	    set number_answer ""
	    set varchar_answer ""
	    set date_answer ""
            set attachment_answer ""
	}
    }

    switch -- $presentation_type {
        "upload_file"  {
	    if {$edit_previous_response_p == "t"} {
		set user_value $attachment_answer
	    }
	    append html "<input type=file name=$element_name $presentation_options>"
	}
	"textbox" {
	    if {$edit_previous_response_p == "t"} {
		if {$abstract_data_type == "number" || $abstract_data_type == "integer"} {
		    set user_value $number_answer
		} else {
		    set user_value $varchar_answer
		}
	    }

	    append html "<input type=text name=$element_name value=\"[philg_quote_double_quotes $user_value]\" [ad_decode $presentation_options "large" "size=70" "medium" "size=40" "size=10"]>"
	}
	"textarea" {
	    if {$edit_previous_response_p == "t"} {

		    set user_value $clob_answer
		}
	    
	    set presentation_options [ad_decode $presentation_options "large" "rows=20 cols=65" "medium" "rows=15 cols=55" "rows=8 cols=35"]
	    append html "<textarea name=$element_name $presentation_options style=\"vertical-align: text-top\">$user_value</textarea>" 
	    }
	"date" {
	    if {$edit_previous_response_p == "t"} {
		set user_value $date_answer
	    }

	    append html "[ad_dateentrywidget $element_name $user_value]" 
	}
	"select" {
	    if { $abstract_data_type == "boolean" } {
		if {$edit_previous_response_p == "t"} {
		    set user_value $boolean_answer
		}
		
		if {![empty_string_p $presentation_options]} {
		    set options_list [split $presentation_options "/"]
		    set choice_t [lindex $options_list 0]
		    set choice_f [lindex $options_list 1]
		} else {
		    set choice_t "True"
		    set choice_f "False"
		}

		append html "<select name=$element_name>
 <option value=\"\">Select One</option>
 <option value=\"t\" [ad_decode $user_value "t" "selected" ""]>$choice_t</option>
 <option value=\"f\" [ad_decode $user_value "f" "selected" ""]>$choice_f</option>
</select>
"
	    } else {
		if {$edit_previous_response_p == "t"} {
		    set user_value $choice_id
		}

# at some point, we may want to add a UI option for the admin
# to sepcify multiple or not for select
		append html "<select name=$element_name>
		<option value=\"\">Select One</option>\n"
		db_foreach question_choices "" {

		    if { $user_value == $choice_id } {
			append html "<option value=$choice_id selected>$label</option>\n"
		    } else {
			append html "<option value=$choice_id>$label</option>\n"
		    }
		}
		append html "</select>"
	    }
	}
    
	"radio" {
	    if { $abstract_data_type == "boolean" } {
		if {$edit_previous_response_p == "t"} {
		    set user_value $boolean_answer
		}
		if {![empty_string_p $presentation_options]} {
		    set options_list [split $presentation_options "/"]
		    set choice_t [lindex $options_list 0]
		    set choice_f [lindex $options_list 1]
		} else {
		    set choice_t "True"
		    set choice_f "False"
		}

		set choices [list "<input type=radio name=$element_name value=t [ad_decode $user_value "t" "checked" ""]> $choice_t" \
				 "<input type=radio name=$element_name value=f [ad_decode $user_value "f" "checked" ""]> $choice_f"]
	    } else {
		if {$edit_previous_response_p == "t"} {
		    set user_value $choice_id
		}
		
		set choices [list]
		db_foreach question_choices_2 "" {
		    if { $user_value == $choice_id } {
			lappend choices "<input type=radio name=$element_name value=$choice_id checked> $label"
		    } else {
			lappend choices "<input type=radio name=$element_name value=$choice_id> $label"
		    }
		}
	    }  
	    if { $presentation_alignment == "beside" } {
		append html [join $choices " "]
	    } else {
		append html "<blockquote>\n[join $choices "<br>\n"]\n</blockquote>"
	    }
	}

	"checkbox" {
	    set choices [list]
	    db_foreach question_choices_3 "" {
		if { [info exists selected_choices($choice_id)] } {
		    lappend choices "<input type=checkbox name=$element_name value=$choice_id checked> $label"
		} else {
		    lappend choices "<input type=checkbox name=$element_name value=$choice_id> $label"
		}
	    }
	    if { $presentation_alignment == "beside" } {
		append html [join $choices " "]
	    } else {
		append html "<blockquote>\n[join $choices "<br>\n"]\n</blockquote>"
	    }
	}
    }

    return $html
}

ad_proc -public util_show_plain_text { text_to_display } "allows plain text (e.g. text entered through forms) to look good on screen without using tags; preserves newlines, angle brackets, etc." {
    regsub -all "\\&" $text_to_display "\\&amp;" good_text
    regsub -all "\>" $good_text "\\&gt;" good_text
    regsub -all "\<" $good_text "\\&lt;" good_text
    regsub -all "\n" $good_text "<br>\n" good_text
    # get rid of stupid ^M's
    regsub -all "\r" $good_text "" good_text
    return $good_text
}

ad_proc -public survey_answer_summary_display {response_id {html_p 1}} "Returns a string with the questions and answers. If html_p =t, the format will be html. Otherwise, it will be text.  If a list of category_ids is provided, the questions will be limited to that set of categories." {

    set return_string ""
    set question_id_previous ""
    
    db_foreach summary "" {

	if {$question_id == $question_id_previous} {
	    continue
	}
	
	if $html_p {
	    append return_string "<b># $sort_order: $question_text</b> 
	<blockquote>"
	} else {
	    append return_string "# $sort_order: $question_text:  "
	}
	append return_string [util_show_plain_text "$clob_answer $number_answer $varchar_answer $date_answer"]
	
	if {![empty_string_p $attachment_answer]} {
	    set package_id [ad_conn package_id]
	    set filename [db_string get_filename {}]
	    append return_string "Uploaded file: <a href=\"[site_node::get_url_from_object_id -object_id $package_id]/view-attachment?[export_url_vars response_id question_id]\">\"$filename\"</a>"
	}
	
	if {$choice_id != 0 && ![empty_string_p $choice_id] && $question_id != $question_id_previous} {
	    set label_list [db_list survey_label_list ""]
	    append return_string "[join $label_list ", "]"
	}
	
	if ![empty_string_p $boolean_answer] {
	    append return_string "[survey_decode_boolean_answer -response $boolean_answer -question_id $question_id]"
	    
	}
	
	if $html_p {
	    append return_string "</blockquote>
	    <P>"
	} else {
	    append return_string "\n\n"
	}
	
	set question_id_previous $question_id 
    }
    
    return "$return_string"
}



ad_proc -public survey_get_score {section_id user_id} "Returns the score of the user's most recent response to a survey" {
    
    set response_id [ survey_get_response_id $section_id $user_id ]
    
    if { $response_id != 0 } {
        set score [db_string get_score "" -default 0]
    } else {
        set score {}
    }
    
    return $score
}


ad_proc -public survey_display_types {
} {
    return {list table paragraph}
}


ad_proc -public survey_question_copy {
    {-new_section_id ""}
    {-question_id:required}
} { copies a question within the same survey
} {
    set user_id [ad_conn user_id]
    db_1row get_question_details {}
    if {![empty_string_p $new_section_id]} {
	set section_id $new_section_id
    }

    set old_question_id $question_id
    if {[empty_string_p $new_section_id]} {
	set after $sort_order
	set new_sort_order [expr {$after + 1}]
	    db_dml renumber_sort_orders {}
    } else {
	set new_sort_order $sort_order
    }

    set new_question_id [db_exec_plsql create_question {}]
    db_dml insert_question_text {}
    db_foreach get_survey_question_choices {} {
	set new_choice_id [db_string get_choice_id {}]
	db_dml insert_survey_question_choice {}
	
    }

  return $new_question_id
}

ad_proc survey_copy { 
    {-survey_id:required} 
    {-package_id ""} 
    {-new_name ""}
} {
    copies a survey, copying all questions, but not responses
    is package_id is specific it copies they survey to another
    survey package instance, otherwise it copies the survey to the
    same package instance
} {

    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    db_1row get_survey_info {}
    if {![empty_string_p $new_name]} {
	set name $new_name
    }
    set user_id [ad_conn user_id]
    set new_survey_id [db_exec_plsql survey_create {} ]
    set sections_list [db_list get_sections {}]


    foreach section_id $sections_list {
    
	set new_section_id [db_exec_plsql section_create {}]
	set new_section_ids($section_id) $new_section_id
	if {![empty_string_p $description]} {
	    db_dml set_section_description {}
	}
    }
   db_foreach get_questions {} {

	survey_question_copy -new_section_id $new_section_ids($section_id) -question_id $question_id
    }
return $new_survey_id

}

ad_proc -public survey_do_notifications {
    {-response_id ""}
} { process notifications when someone responds to a survey
    or edits a response
} {

        set survey_id [db_string get_survey_id_from_response {}]
	get_survey_info -survey_id $survey_id
	set survey_name $survey_info(name)
	set subject "Response to $survey_name"

        #dotlrn specific info
    set dotlrn_installed_p [apm_package_installed_p dotlrn]
    if {$dotlrn_installed_p} {
	set package_id [ad_conn package_id]
	set community_id [dotlrn_community::get_community_id]
	set segment_id [dotlrn_community::get_rel_segment_id -community_id $community_id -rel_type "dotlrn_member_rel"]
	set community_name [dotlrn_community::get_community_name $community_id]
	set community_url "[ad_parameter -package_id [ad_acs_kernel_id] SystemURL][dotlrn_community::get_community_url $community_id]"
    }
	db_1row get_response_info {
	select r.initial_response_id, r.responding_user_id, r.response_id,
	    u.first_names || ' ' || u.last_name as user_name,
	    edit_p,
	    o.creation_date as response_date
	    from (select survey_response.initial_user_id(response_id) as responding_user_id,
		  survey_response.initial_response_id(response_id) as initial_response_id,
		  response_id, (case when initial_response_id is NULL then 'f' else 't' end) as edit_p
	    from survey_responses) r, acs_objects o,
	    cc_users u where r.response_id=:response_id
	    and r.responding_user_id = u.user_id
	    and r.response_id = o.object_id
	}
	
	set notif_text ""
	if {$dotlrn_installed_p} {
	    append notif_text "
Group: $community_name"
        }
	append notif_text "
Survey: $survey_name
Respondent: $user_name 

Here is what $user_name <[acs_community_member_url -user_id $responding_user_id]>
had to say in response to $survey_name:
	"

	if {$edit_p} {
	    append notif_text "
Edited "
	}
	append notif_text "Response on $response_date\n"

	append notif_text [survey_answer_summary_display $response_id 0]

# add summary info for sloanspace
	if {$dotlrn_installed_p} {
	set n_responses [db_string n_responses {}]
	if {$n_responses > 0} {
	    append notif_text " -----
Already Responsed: $n_responses users

View these users. <$community_url/survey/admin/respondents?response_type=responded>

Spam these users. <$community_url/survey/admin/send-mail?survey_id=$survey_id&to=responded>

"
        }
	set n_members [db_string n_members {}]
        set n_awaiting [expr {$n_members - $n_responses}]

        append notif_text "
Awaiting a response: $n_awaiting users

View these users. <$community_url/survey/admin/respondents?response_type=not_responded>

Spam these users. <$community_url/survey/admin/send-mail?survey_id=$survey_id&to=not_responded>

The whole group: $n_members

View these users. <$community_url/survey/admin/respondents?response_type=all>

Spam these users. <$community_url/survey/admin/send-mail?survey_id=$survey_id&to=all>

Responses:
"

        db_foreach get_questions {} {
        append notif_text "$sort_order.    $question_text - View responses. <$community_url/survey/view-text-responses?question_id=$question_id>
    "
        }
    }
	notification::new \
            -type_id [notification::type::get_type_id \
			  -short_name survey_response_notif] \
            -object_id $survey_id \
            -response_id $survey_id \
            -notif_subject $subject \
            -notif_text $notif_text
    
}


ad_proc survey_decode_boolean_answer { 
    {-response:required}
    {-question_id:required}
} {
    takes t/f value from a boolean_answer column and 
    decodes it based on the presentation_options of the question

    @author Dave Bauer <dave@thedesignexperience.org>

    @param -response text value of response to be decoded
    @param -question_id question_id of question response is from
} {
    set presentation_options [db_string get_presentation_options {}]
    if {[empty_string_p $presentation_options]} {
	set presentation_options "True/False"
    }


    if {![empty_string_p $response]} {
	set options_list [split $presentation_options "/"]

	if {$response=="t"} {
	    set response [lindex $options_list 0]
	} else {
	    set response [lindex $options_list 1]
	}
    } 
    return $response
}