##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##


require 'msf/core'
require 'rex'

class MetasploitModule < Msf::Post

  include Msf::Post::Windows::Priv
  include Msf::Post::Windows::ShadowCopy

  def initialize(info={})
    super(update_info(info,
      'Name'                 => "Windows Manage Create Shadow Copy",
      'Description'          => %q{
        This module will attempt to create a new volume shadow copy.
        This is based on the VSSOwn Script originally posted by
        Tim Tomes and Mark Baggett.

        Works on win2k3 and later.
        },
      'License'              => MSF_LICENSE,
      'Platform'             => ['win'],
      'SessionTypes'         => ['meterpreter'],
      'Author'               => ['theLightCosine'],
      'References'    => [
        [ 'URL', 'http://pauldotcom.com/2011/11/safely-dumping-hashes-from-liv.html' ]
      ]
    ))
    register_options(
      [
        OptString.new('VOLUME', [ true, 'Volume to make a copy of.', 'C:\\'])
      ], self.class)

  end


  def run
    unless is_admin?
      print_error("This module requires admin privs to run")
      return
    end
    if is_uac_enabled?
      print_error("This module requires UAC to be bypassed first")
      return
    end
    unless start_vss
      return
    end
    id = create_shadowcopy(datastore['VOLUME'])
    if id
      print_good "Shadow Copy #{id} created!"
    end
  end



end
