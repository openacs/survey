<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_question">      
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

<fullquery name="get_choice_id">
<querytext>
select survey_choice_id_sequence.nextval as choice_id
</querytext>
</fullquery>

</queryset>