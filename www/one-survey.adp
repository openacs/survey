<master>
<property name="title">Surveys</property>
<property name="context_bar">@context_bar@</property>
<if @admin_p@ eq "1"><p style="text-align: right;"><a href="admin/"><img src="graphics/admin.gif" border="0" alt="Admin"></a></p></if>
    <ul>
      
      <multiple name="survey_details">
	<li>@survey_details.name@
	  <if @survey_details.single_response_p@ eq "t" and
	@survey_details.response_id@ nil> <a
	href="respond?survey_id=@survey_details.survey_id@"><img src="graphics/answer.gif" border="0" alt="Answer Survey"></a></if>
	  <if @survey_details.single_response_p@ eq "f"><a
	href="respond?survey_id=@survey_details.survey_id@"><img src="graphics/answer.gif" border="0" alt="Answer Survey"></a></if>
	</li>
	<if @survey_details.response_id@ not nil>

	<group column="survey_id">
	<ul>
	    <li>Previous response on: @survey_details.creation_date@
	    <a href="one-respondent?survey_id=@survey_details.survey_id@&amp;#@survey_details.response_id@"><img src="graphics/view.gif" border="0" alt="View Response"></a>
	    <if @survey_details.editable_p@ eq "t">
	    <a href="respond?survey_id=@survey_details.survey_id@&response_id=@survey_details.response_id@"><img src="graphics/edit.gif" border="0" alt="Edit Response"></a></if>
	    </li>
	 </ul>

	</group>
	</if>
      </multiple>
      
    </ul>

