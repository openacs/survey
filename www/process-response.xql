<?xml version="1.0"?>
<queryset>

<fullquery name="section_exists">      
      <querytext>
      
	    select 1 from survey_sections where section_id = :section_id
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_info_list">      
      <querytext>
      
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_info_list">      
      <querytext>
      
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_checkbox_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_choice_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_choice_shorttext_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, varchar_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_boolean_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, boolean_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_integer_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, number_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_date_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, date_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="get_type">      
      <querytext>
      select type from survey_sections where section_id = :section_id
      </querytext>
</fullquery>

 
<fullquery name="survey_name_from_id">      
      <querytext>
      select name from survey_sections where section_id = :section_id
      </querytext>
</fullquery>

 
<fullquery name="get_score">      
      <querytext>
      select variable_name, sum(score) as sum_of_scores
                           from survey_choice_scores, survey_question_responses, survey_variables
                           where survey_choice_scores.choice_id = survey_question_responses.choice_id
                           and survey_choice_scores.variable_id = survey_variables.variable_id
                           and survey_question_responses.response_id = :response_id
                           group by variable_name
      </querytext>
</fullquery>

 
<fullquery name="get_logic">      
      <querytext>
      select logic from survey_logic, survey_logic_surveys_map
          where survey_logic.logic_id = survey_logic_surveys_map.logic_id
          and section_id = :section_id
      </querytext>
</fullquery>


<fullquery name="survey_question_response_file_attachment_insert">
      <querytext>
      insert into survey_question_responses
      (response_id, question_id, attachment_file)
       values
      (:response_id, :question_id, :revision_id)
      </querytext>
</fullquery>

</queryset>
