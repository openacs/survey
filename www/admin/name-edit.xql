<?xml version="1.0"?>
<queryset>
<fullquery name="survey_update">
<querytext>
update surveys 
set name= :name,
    description= :description
where survey_id = :survey_id
</querytext>
</fullquery>
</queryset>
