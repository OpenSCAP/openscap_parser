# Remediation is applicable only in certain platforms
if [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; then

var_selinux_state='enforcing'


if [ -e "/etc/selinux/config" ] ; then
    
    LC_ALL=C sed -i "/^SELINUX=/Id" "/etc/selinux/config"
else
    touch "/etc/selinux/config"
fi
# make sure file has newline at the end
sed -i -e '$a\' "/etc/selinux/config"

cp "/etc/selinux/config" "/etc/selinux/config.bak"
# Insert at the end of the file
printf '%s\n' "SELINUX=$var_selinux_state" >> "/etc/selinux/config"
# Clean up after ourselves.
rm "/etc/selinux/config.bak"

fixfiles onboot
fixfiles -f relabel

else
    >&2 echo 'Remediation is not applicable, nothing was done'
fi
