ad_page_contract {

    Lists all the enabled surveys
    a user is eligible to complete.

    @author  philg@mit.edu
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id  $Id$
} {

} -properties {
    surveys:multirow
}

set package_id [ad_conn package_id]

set user_id [auth::require_login]

set admin_p [permission::permission_p -object_id $package_id -privilege admin]

db_multirow surveys survey_select {} 


ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
