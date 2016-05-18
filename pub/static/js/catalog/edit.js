$(function(){

  var item_id = $("#item_id").val();

  $('#edit-cat').modal({
    "backdrop":'static'
  });

  getCatList();

  function getCatList(){
      $.get(
        "/item/catlist",
        { "item_id": item_id },
        function(data){
          $("#show-cat").html('');
          if (data.code == 200) {
            json = data.data;
            for (var i = 0; i < json.length; i++) {
                cat_html ='<a class="badge badge-info single-cat " href="/item/catalog?cat_id='+json[i].cat_id+'&item_id='+json[i].item_id+'">'+json[i].cat_name+'&nbsp;<i class="icon-edit"></i></a>';
                $("#show-cat").append(cat_html);
            };
          };
        },
        "json"
        );
  }

  //保存目录
  $("#save-cat").click(function(){
      var cat_name = $("#cat_name").val();
      var order = $("#order").val();
      var cat_id = $("#cat_id").val();
      $.post(
        "/item/savecat",
        {"cat_name": cat_name , "order": order , "item_id": item_id , "cat_id": cat_id  },
        function(data){
          console.log(data);
          if (data.success) {
            $("#delete-cat").hide();
            $("#cat_name").val('');
            $("#order").val('');
            $("#cat_id").val('');
            alert("保存成功！");
          }else{
            alert("保存失败！");
          }
          getCatList();
        },
        "json"
        );
      return false;
  });

  //删除目录
  $("#delete-cat").click(function(){
    if(confirm('确认删除吗？')){
        var cat_id = $("#cat_id").val();
        if (cat_id > 0 ) {
            $.post(
                "/item/delcat",
                { "cat_id": cat_id  },
                function(data){
                  if (data.code==200) {
                    alert("删除成功！");
                    window.location.href="/item/catalog?item_id="+item_id;
                  }else{
                    alert("删除失败！");
                  }
                },
                "json"
              );
        }
    }

      return false;
  })

  $(".exist-cat").click(function(){
    window.location.href="../item/show?id="+item_id;
  });
});









