<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_initial_response">      
      <querytext>
      
	select survey_response__initial_response_id(:response_id) as initial_response_id from dual

      </querytext>
</fullquery>

<fullquery name="count_responses">      
      <querytext>
      select count(*) from survey_responses
	where survey_id=:survey_id
	and survey_response__initial_user_id(response_id)=:user_id
	and initial_response_id is null
      </querytext>
</fullquery>

 
</queryset>
