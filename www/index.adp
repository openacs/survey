<master>
<property name="title">Surveys</property>
<property name="context_bar">@context_bar@</property>
<if @admin_p@ eq "1"><p style="text-align: right;"><a href="admin/"><img src="/graphics/admin.gif" border="0" alt="Administer Surveys"></a></if>
    <ul>
      
      <multiple name="surveys">
	<li>@surveys.name@
	  <if @surveys.single_response_p@ eq "t" and
	@surveys.response_id@ nil> <a
	href="respond?survey_id=@surveys.survey_id@"><img src="/graphics/answer.gif" border="0" alt="Answer Survey"></a></if>
	  <if @surveys.single_response_p@ eq "f"><a
	href="respond?survey_id=@surveys.survey_id@"><img src="/graphics/answer.gif" border="0" alt="Answer Survey"></a></if>
	</li>
	<if @surveys.response_id@ not nil>
	<ul>
	  <group column="survey_id">
	    <li>Previous response on: @surveys.creation_date@
	    <a href="one-respondent?survey_id=@surveys.survey_id@&amp;#@surveys.response_id@"><img src="/graphics/view.gif" border="0" alt="View Response"></a>
	    <if @surveys.editable_p@ eq "t">
	    <a href="respond?survey_id=@surveys.survey_id@&response_id=@surveys.response_id@"><img src="/graphics/edit.gif" border="0" alt="Edit Response"></a></if>
	    </li>
          </group>
	 </ul>
	</if>
      </multiple>
      
      <if @surveys:rowcount@ eq 0>
	<li>No surveys active
	  
      </if>
    </ul>

