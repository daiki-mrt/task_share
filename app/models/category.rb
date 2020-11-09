class Category < ActiveHash::Base

  self.data = [
    {id: 0, name: "選択して下さい"},
    {id: 1, name: "ビジネス"},
    {id: 2, name: "趣味"},
    {id: 3, name: "その他"},
  ]
  
end