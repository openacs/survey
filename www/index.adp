<master>
<property name="title">#survey.Surveys#</property>
<property name="context_bar">@context_bar;noquote@</property>
<if @admin_p@ eq "1"><p style="text-align: right;"><a href="admin/">#survey.lt_img_srcgraphicsadming#</a></if>
    <ul>
      
      <multiple name="surveys">
	<li>@surveys.name@
	  <if @surveys.single_response_p@ eq "t" and
	@surveys.response_id@ nil> <a
	href="respond?survey_id=@surveys.survey_id@">#survey.Answer_Survey#</a></if>
	  <if @surveys.single_response_p@ eq "f"><a
	href="respond?survey_id=@surveys.survey_id@">#survey.Answer_Survey#</a></if>
	</li>
	<if @surveys.response_id@ not nil>
	<ul>
	  <group column="survey_id">
	    <li>#survey.lt_Previous_response_on_#
	    <a href="one-respondent?survey_id=@surveys.survey_id@&amp;#@surveys.response_id@">#survey.View_Response#</a>
	    <if @surveys.editable_p@ eq "t">
	    <a href="respond?survey_id=@surveys.survey_id@&response_id=@surveys.response_id@">#survey.Edit_Response#</a></if>
	    </li>
          </group>
	 </ul>
	</if>
      </multiple>
      
      <if @surveys:rowcount@ eq 0>
	<li>#survey.No_surveys_active#
	  
      </if>
    </ul>



