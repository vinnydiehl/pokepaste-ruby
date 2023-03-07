def test_paste_equality(a, b)
  %w[species nickname gender item evs ivs shiny?
     ability tera_type level happiness nature moves].each do |attr|
    a.each_with_index do |pkmn, index|
      expect(pkmn.send attr).to eq b[index].send(attr)
    end
  end
end
