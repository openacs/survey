<master>

<property name=title>Survey Administration</property>
<property name=context_bar>@context_bar@</property>
<property name="link_all">1</property>
<ul>
<multiple name=surveys>
<group column="enabled_p">
<li> <a href=one?survey_id=@surveys.survey_id@>@surveys.name@</a> 
<if @surveys.enabled_p@ eq "f"><span style="color: #f00">(disabled)</span></if>
</group>
</multiple>
<p>
<li> <a href=survey-create>New Survey</a>
</ul>
