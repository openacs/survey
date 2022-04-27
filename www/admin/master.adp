<master>
<if @context_bar@ not nil>
<property name="context_bar">@context_bar;literal@</property>
</if>
<if @context@ not nil>
<property name="context">@context;literal@</property>
</if>
<if @title@ not nil>
<property name="doc(title)">@title;literal@</property>
</if>
<if @focus@ not nil><property name="focus">@focus;literal@</property></if>
<a href=".">#survey.lt_Main_Survey_Administr#</a>  | <a href="one?survey_id=@survey_id@">#survey.Admin_This_Survey#</a> 
<p>
<slave>

