<?xml version="1.0"?>
<queryset>

<fullquery name="section_id_from_question_id">      
      <querytext>
	select sq.section_id, sec.survey_id
	  from survey_questions sq, survey_sections sec
	 where sq.question_id = :question_id
	   and sq.section_id = sec.section_id
      </querytext>
</fullquery>

 
<fullquery name="survey_question_responses_delete">      
      <querytext>
      delete from survey_question_responses where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="survey_question_choices_score_delete">
      <querytext>

      delete from survey_choice_scores
      where choice_id in (select choice_id from survey_question_choices
          where question_id = :question_id)

      </querytext>
</fullquery>

 
<fullquery name="survey_question_choices_delete">      
      <querytext>
      delete from survey_question_choices where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="survey_questions_delete">      
      <querytext>
      delete from survey_questions where question_id = :question_id
      </querytext>
</fullquery>

 
</queryset>
