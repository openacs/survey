<master src="master">
<property name="survey_id">@survey_id@</property>

<property name=title>People who answered @response_text@</property>
<property name=context_bar>@context_bar@</property>

@survey_name@ responders who answered @response_text@
when asked @question_text@:

<ul>
<multiple name="user_responses">
<li><a href="one-respondent?user_id=@user_responses.user_id@&survey_id=@survey_id@">@user_responses.responder_name@</a></li>

</multiple>
</ul>
