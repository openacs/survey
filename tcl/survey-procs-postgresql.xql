<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_question_copy.create_question">      
      <querytext>
	    begin
		PERFORM survey_question__new (
		    NULL,
		    :section_id,
                    :new_sort_order,
                    :question_text,
                    :abstract_data_type,
		    :required_p,
                    :active_p,
		    :presentation_type,
		    :presentation_options,
	            :presentation_alignment,
		    :user_id,
		    :section_id
		);
	    end;
      </querytext>
</fullquery>

<fullquery name="survey_question_copy.get_choice_id">
<querytext>
select survey_choice_id_sequence.nextval as choice_id
</querytext>
</fullquery>

<fullquery name="survey_do_notifications.get_response_info">
    <querytext>
	select r.initial_response_id, r.responding_user_id, r.response_id,
	    u.first_names || ' ' || u.last_name as user_name,
	    edit_p,
	    o.creation_date as response_date
	    from (select survey_response__initial_user_id(response_id) as responding_user_id,
		  survey_response__initial_response_id(response_id) as initial_response_id,
		  response_id, (case when initial_response_id is NULL then 'f' else 't' end) as edit_p
	    from survey_responses) r, acs_objects o,
	    cc_users u where r.response_id=:response_id
	    and r.responding_user_id = u.user_id
	    and r.response_id = o.object_id
    </querytext>
</fullquery>
</queryset>