<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

 
<fullquery name="get_responses">      
      <querytext>
      select response_id, case when initial_response_id is NULL then 'T' else 'F' end as original_p, nvl(initial_response_id,response_id) as initial_response, creation_date 
from survey_responses, acs_objects
where response_id = object_id
and creation_user = :user_id
and survey_id=:survey_id
order by creation_date desc
      </querytext>
</fullquery>

</queryset>