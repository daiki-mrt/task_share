class Occupation < ActiveHash::Base

  self.data = [
    # {id: 0, name: "選択して下さい"},
    {id: 1, name: "会社員"},
    {id: 2, name: "自営業"},
    {id: 3, name: "アルバイト・パート"},
    {id: 4, name: "学生"},
    {id: 5, name: "その他"}
  ]
  
end