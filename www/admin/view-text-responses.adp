<master src="master">

<property name="survey_id">@survey_id@</property>

<property name="title">@survey_name@: Responses to Question</property>
<property name="context_bar">@context_bar@</property>
@question_text@
<hr />
<if @responses:rowcount@ eq 0>
	<em>No Responses</em>
	</if>
      <multiple name="responses">
<a
	  href="one-respondent?user_id=@responses.creation_user@&survey_id=@survey_id@">@responses.respondent_name@</a>
	  on @responses.submission_date@ | @responses.response@
<br />
</multiple>