class TempMechanic < ApplicationRecord
  def description_hash
    s = "M30L30Y10TW20TN90"
    s = description
    s=s.sub('NM',"")
    s=s.sub('NL',"")
    s=s.sub('JLD',"|JZD:")
    s=s.sub('JLS',"|JZS:")
    s=s.sub('M',"|M:")
    s=s.sub('L',"|L:")
    s=s.sub('Y',"|Y:")
    s=s.sub('DJ',"|DJ:")
    s=s.sub('TW',"|TW:")
    s=s.sub('TN',"|TN:")
    s[0]=""
    
    array = Array.new
    array = s.split(/\:|\|/)
    if (array.size%2==0)
    hash = Hash[*array]
    else
    print "id:", mechanic_id, "\n"
    end
  end
end
