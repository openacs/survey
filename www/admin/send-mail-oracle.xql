<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <partialquery name="dotlrn_all">
	<querytext>
            select '$sender_email' as from_addr,
               '$sender_first_names' as sender_first_names,
               '$sender_last_name' as sender_last_name,
               parties.email,
               decode(acs_objects.object_type,
                      'user',
                      (select first_names
                       from persons
                       where person_id = parties.party_id),
                      'group',
                      (select group_name
                       from groups
                       where group_id = parties.party_id),
                      'rel_segment',
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id),
                      '') as first_names,
               decode(acs_objects.object_type,
                      'user',
                      (select last_name
                       from persons
                       where person_id = parties.party_id),
                      '') as last_name,
               '$community_name' as community_name,
               '$community_url' as community_url
            from party_approved_member_map,
                 parties,
                 acs_objects
            where party_approved_member_map.party_id = $segment_id
            and party_approved_member_map.member_id <> $segment_id
            and party_approved_member_map.member_id = parties.party_id
            and parties.party_id = acs_objects.object_id
	</querytext>
    </partialquery>

    <partialquery name="dotlrn_responded">
	<querytext>
 		select '$sender_email' as from_addr,
               '$sender_first_names' as sender_first_names,
               '$sender_last_name' as sender_last_name,
               parties.email,
               decode(acs_objects.object_type,
                      'user',
                      (select first_names
                       from persons
                       where person_id = parties.party_id),
                      'group',
                      (select group_name
                       from groups
                       where group_id = parties.party_id),
                      'rel_segment',
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id),
                      '') as first_names,
               decode(acs_objects.object_type,
                      'user',
                      (select last_name
                       from persons
                       where person_id = parties.party_id),
                      '') as last_name,
               '$community_name' as community_name,
               '$community_url' as community_url
            from party_approved_member_map,
                 parties,
                 acs_objects
            where party_approved_member_map.party_id = $segment_id
            and party_approved_member_map.member_id <> $segment_id
            and party_approved_member_map.member_id = parties.party_id
            and parties.party_id = acs_objects.object_id
	    and parties.party_id in (
		select survey_response.initial_user_id(response_id)
		from survey_responses_latest where survey_id=$survey_id)
	</querytext>
    </partialquery>

    <partialquery name="dotlrn_not_responded">
	<querytext>
		select '$sender_email' as from_addr,
               '$sender_first_names' as sender_first_names,
               '$sender_last_name' as sender_last_name,
               parties.email,
               decode(acs_objects.object_type,
                      'user',
                      (select first_names
                       from persons
                       where person_id = parties.party_id),
                      'group',
                      (select group_name
                       from groups
                       where group_id = parties.party_id),
                      'rel_segment',
                      (select segment_name
                       from rel_segments
                       where segment_id = parties.party_id),
                      '') as first_names,
               decode(acs_objects.object_type,
                      'user',
                      (select last_name
                       from persons
                       where person_id = parties.party_id),
                      '') as last_name,
               '$community_name' as community_name,
               '$community_url' as community_url
            from party_approved_member_map,
                 parties,
                 acs_objects
            where party_approved_member_map.party_id = $segment_id
            and party_approved_member_map.member_id <> $segment_id
            and party_approved_member_map.member_id = parties.party_id
            and parties.party_id = acs_objects.object_id
	    and parties.party_id not in (
            select survey_response.initial_user_id(response_id)
            from survey_responses_latest where survey_id=$survey_id)
	</querytext>
    <partialquery>

    <partialquery name="responded">
	<querytext>
 		select '$sender_email' as from_addr,
               '$sender_first_names' as sender_first_names,
               '$sender_last_name' as sender_last_name,
               parties.email,
            from parties
            where parties.party_id = acs_objects.object_id
	    and parties.party_id in (
		select survey_response.initial_user_id(response_id)
		from survey_responses_latest where survey_id=$survey_id)
	</querytext>
    <partialquery>

</queryset>