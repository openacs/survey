<?xml version="1.0"?>
<queryset>

    <fullquery name="get_n_responses">
	<querytext>
	    select count(*) from survey_responses_latest
	    where survey_id=:survey_id
	</querytext>
    </fullquery>

    <fullquery name="get_filename">
	<querytext>
	    select title from cr_revisions where
	    revision_id=:attachment_answer
	</querytext>
    </fullquery>

</queryset>