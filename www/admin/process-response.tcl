ad_page_contract {

    Insert user response into database.
    This page receives an input for each question named
    response_to_question.$question_id 
    Adapted from www/process-reponse.tcl

    @param   section_id             survey user is responding to
    @param   return_url            optional redirect address
    @param   group_id              
    @param   response_to_question  since form variables are now named as response_to_question.$question_id, this is actually array holding user responses to all survey questions.
    
    @param   edited_response_id  id of the response we are editing
    @author  teadams@alum.mit.edu
    @date    1 April 2003
    @cvs-id $Id$
} {
  survey_id:integer
  section_id:integer
  {initial_response_id:integer 0}
  {edited_response_id:integer 0}
  return_url:optional
  response_to_question:array,optional,multiple,html
  new_response_id:integer
} -validate {

    section_exists -requires { section_id } {
	if ![db_0or1row section_exists {}] {
	    ad_complain "Section $section_id does not exist"
	}
    }

    check_questions -requires { section_id:integer } {

	set question_info_list [db_list_of_lists survey_question_info_list {
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	}]
	    
	## Validate input.
	
	set questions_with_missing_responses [list]
	
	foreach question $question_info_list { 
	    set question_id [lindex $question 0]
	    set question_text [lindex $question 1]
	    set abstract_data_type [lindex $question 2]
	    set required_p [lindex $question 4]
	    
	    #  Need to clean-up after mess with :array,multiple flags
	    #  in ad_page_contract.  Because :multiple flag will sorround empty
	    #  strings and all multiword values with one level of curly braces {}
	    #  we need to get rid of them for almost any abstract_data_type
	    #  except 'choice', where this is intended behaviour.  Why bother
	    #  with :multiple flag at all?  Because otherwise we would lost all
	    #  but first value for 'choice' abstract_data_type - see ad_page_contract
	    #  doc and code for more info.
	    #
	    if { [exists_and_not_null response_to_question($question_id)] } {
		if {$abstract_data_type != "choice"} {
		    set response_to_question($question_id) [join $response_to_question($question_id)]
		} else {
		    if { [empty_string_p [lindex $response_to_question($question_id) 0 ] ] } {
		        set response_to_question($question_id) ""
		    }
	        }
	    }
	    	    
	    if { $abstract_data_type == "date" } {
		if [catch  { set response_to_question($question_id) [validate_ad_dateentrywidget "" response_to_question.$question_id [ns_getform]]} errmsg] {
		    ad_complain "$errmsg: Please make sure your dates are valid."
		}
	    }
	        
	    if { [exists_and_not_null response_to_question($question_id)] } {
		set response_value [string trim $response_to_question($question_id)]
	    } elseif {$required_p == "t"} {
	
		# When the administrator edits a survey, the file is not
		# prefilled into the form like the rest of the fields.
		# If the question is a file_upload and we are editing,
		# it is not required to enter a file.  Instead, the
		# file from the prior response will be used.

		if { $abstract_data_type != "blob" || [empty_string_p $initial_response_id]} {
		    lappend questions_with_missing_responses $question_text
		    continue
		}
		    
	    } else {
		set response_to_question($question_id) ""
		set response_value ""
	    }
	    
	    if {![empty_string_p $response_value]} {
		if { $abstract_data_type == "number" } {
		    if { ![regexp {^(-?[0-9]+\.)?[0-9]+$} $response_value] } {
			
			ad_complain "The response to \"$question_text\" must be a number. Your answer was \"$response_value\"."
			continue
		    }
		} elseif { $abstract_data_type == "integer" } {
		    if { ![regexp {^[0-9]+$} $response_value] } {
			
			ad_complain "The response to \"$question_text\" must be an integer. Your answer was \"$response_value\"."
			continue
		}
		}
	    }
	    
	    if { $abstract_data_type == "blob" } {
                set tmp_filename $response_to_question($question_id.tmpfile)
		set n_bytes [file size $tmp_filename]
		if { $n_bytes == 0 && $required_p == "t" && 
		          [empty_string_p $initial_response_id]} {
		    
		    ad_complain "Your file is zero-length. Either you attempted to upload a zero length file, a file which does not exist, or something went wrong during the transfer."
		}
	    }
	    
	}
	
	if { [llength $questions_with_missing_responses] > 0 } {
	    ad_complain "You didn't respond to all required sections. You skipped:"
	    foreach skipped_question $questions_with_missing_responses {
		ad_complain $skipped_question
	    }
	    return 0
	} else {
	    return 1
	}
    }

} -properties {

    survey_name:onerow
}

ad_require_permission $survey_id survey_take_survey

set user_id [ad_verify_and_get_user_id]

get_survey_info -survey_id $survey_id
set type $survey_info(type)
set survey_id $survey_info(survey_id)
set survey_name $survey_info(name)

# Do the inserts.
# here we need to decide if it is an edit or multiple response, and create
# a new response, possibly linked to a previous response.

# moved to respond.tcl for double-click protection
# set response_id [db_nextval acs_object_id_seq]

# teadams - 
# From what I can tell, editing a response creates
# a new response in the database, complete with a 
# a response_id that is unique from the initial response.
# 
# Said another way, get_response_count would return
# no rows if it were a new or edited response because
# a new id is generated in respond.tcl.

# The creator of the first version.
# 

if {$initial_response_id==0} {
    set initial_response_id ""
    set initial_creation_user_id $user_id
} else {
    db_1row get_initial_creation_user_id {}
}

if {[db_string get_response_count {}] == 0} {

    set response_id $new_response_id

    set creation_ip [ad_conn peeraddr]

    db_transaction {

	db_exec_plsql create_response {}

	set question_info_list [db_list_of_lists survey_question_info_list {
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order }]

	foreach question $question_info_list { 
	    set question_id [lindex $question 0]
	    set question_text [lindex $question 1]
	    set abstract_data_type [lindex $question 2]
	    set presentation_type [lindex $question 3]


	    set response_value [string trim $response_to_question($question_id)]

	    switch -- $abstract_data_type {
		"choice" {
		    if { $presentation_type == "checkbox" } {
			# Deal with multiple responses. 
			set checked_responses $response_to_question($question_id)
			foreach response_value $checked_responses {
			    if { [empty_string_p $response_value] } {
				set response_value [db_null]
			    }

			    db_dml survey_question_response_checkbox_insert "insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)"
			}
		    }  else {
			if { [empty_string_p $response_value] || [empty_string_p [lindex $response_value 0]] } {
			    set response_value [db_null]
			}

			db_dml survey_question_response_choice_insert "insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)"
		    }
		}
		"shorttext" {
		    db_dml survey_question_choice_shorttext_insert "insert into survey_question_responses (response_id, question_id, varchar_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"boolean" {
		    if { [empty_string_p $response_value] } {
			set response_value [db_null]
		    }

		    db_dml survey_question_response_boolean_insert "insert into survey_question_responses (response_id, question_id, boolean_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"integer" -
		"number" {
		    if { [empty_string_p $response_value] } {
			set response_value [db_null]
		    } 
		    db_dml survey_question_response_integer_insert "insert into survey_question_responses (response_id, question_id, number_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"text" {
		    if { [empty_string_p $response_value] } {
			set response_value [db_null]
		    }

		    db_dml survey_question_response_text_insert "
insert into survey_question_responses
(response_id, question_id, clob_answer)
values (:response_id, :question_id, empty_clob())
returning clob_answer into :1" -clobs [list $response_value]
	    }
	    "date" {
                if { [empty_string_p $response_value] } {
                    set response_value [db_null]
                }

		db_dml survey_question_response_date_insert "insert into survey_question_responses (response_id, question_id, date_answer)
values (:response_id, :question_id, :response_value)"
	    }   
            "blob" {

                if { ![empty_string_p $response_value] } {
                    # this stuff only makes sense to do if we know the file exists
		    set tmp_filename $response_to_question($question_id.tmpfile)

                    set file_extension [string tolower [file extension $response_value]]
                    # remove the first . from the file extension
                    regsub {\.} $file_extension "" file_extension
                    set guessed_file_type [ns_guesstype $response_value]

                    set n_bytes [file size $tmp_filename]
                    # strip off the C:\directories... crud and just get the file name
                    if ![regexp {([^/\\]+)$} $response_value match client_filename] {
                        # couldn't find a match
                        set client_filename $response_value
                    }
                    if { $n_bytes == 0 } {
                        error "This should have been checked earlier."
                    } else {
                         set unique_name "${response_value}_${response_id}"
                         set mime_type [cr_filename_to_mime_type -create $client_filename]

                         set revision_id [cr_import_content -title $client_filename "" $tmp_filename $n_bytes $mime_type $unique_name ]
# we use cr_import_content now --DaveB
# this abstracts out for use the blob handling for oracle or postgresql
# we are linking the file item_id to the survey_question_response attachment_answer field now
                            db_dml survey_question_response_file_attachment_insert ""
                   }
	       }  else {
		   # There was no response.  

		   if {![empty_string_p $initial_response_id]} {
		       # There was a prior response
		       # Get the revision_id for this question from the
		       # prior question.
		       
		       if {[db_0or1row survey_prior_attachment_response {}]} { 
			   set revision_id $attachment_answer
			   db_dml survey_question_response_file_attachment_insert ""
		       }

		   }
		
	       }
	   }
       }
   }
}

}

if {[info exists return_url] && ![empty_string_p $return_url]} {
    ad_returnredirect "$return_url"
           ad_script_abort
} else {
     set context_bar [ad_context_bar "Response Submitted for $survey_name"]
     ad_return_template
}	
    