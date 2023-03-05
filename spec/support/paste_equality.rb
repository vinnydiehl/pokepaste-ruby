def test_paste_equality(a, b)
  %w[species nickname gender item evs ivs shiny?
     ability tera_type level happiness nature moves].each do |attr|
    expect(a.send attr).to eq b.send(attr)
  end
end
