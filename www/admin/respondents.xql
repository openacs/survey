<?xml version="1.0"?>
<queryset>

    <fullquery name="select_respondents">      
        <querytext>
            select persons.first_names, persons.last_name,
                   acs_objects.creation_user as user_id,
                   parties.email
            from survey_responses_latest s,
                 persons,
                 parties,
                 acs_objects
            where s.survey_id=:survey_id
            and s.response_id = acs_objects.object_id
            and acs_objects.creation_user = persons.person_id
            and persons.person_id = parties.party_id
            group by acs_objects.creation_user,
                     parties.email,
                     persons.first_names,
                     persons.last_name
    [ad_order_by_from_sort_spec $orderby $table_def]
        </querytext>
    </fullquery>

</queryset>
