ad_page_contract {

    Lists all the enabled surveys
    a user is eligable to complete.

    @author  philg@mit.edu
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id  $Id$
} {

} -properties {
    surveys:multirow
}

set package_id [ad_conn package_id]

set user_id [ad_maybe_redirect_for_registration]

set admin_p [ad_permission_p $package_id admin]

db_multirow surveys survey_select {} 


ad_return_template

