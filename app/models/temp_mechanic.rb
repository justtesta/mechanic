class TempMechanic < ApplicationRecord
  def description_hash
    s = "M30L30Y10TW20TN90"
    s = description.strip
    s=s.sub('SLDW',"|SZDW:")
    s=s.sub('BXG',"|BXG:")
    s=s.sub('CTB',"|CTB:")
    s=s.sub('DSCP',"|DSCP:")
    s=s.sub('BJPQ',"|BJPQ:")
    s=s.sub('JLY',"|JZZ:0")
    s=s.sub('DH',"|DZ:0")
    s=s.sub('TYM',"|TZZ:0")
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
    s=s.sub('QSCP',"|QSCP:")
    s=s.sub('HSCP',"|ZSCP:")
    s=s.sub('H',"|H:")
    s=s.sub('XC',"|XC:")
    s=s.sub('zt',"|zt:")
    s=s.sub('zd',"|zd:")
    s=s.sub('jd',"|jd:")
    s[0]=""
    
    array = Array.new
    array = s.split(/\:|\|/)
    if (array.size%2==0)
    hash = Hash[*array]
    else
    print "id:", mechanic_id, "\n"
    Rails.logger.info "error mechanic_id:##{mechanic_id} "
    update_attribute(:addr,"2")
    end
    
    
    
  end
end
