<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
<fullquery name="delete_survey">
<querytext>
begin
	survey__remove(:survey_id);
end;
</querytext>
</fullquery>

</queryset>