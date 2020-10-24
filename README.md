# more_getx
GetBuilderC : this simple version of GetBuilder but take controller directly not using Get.find so also remove all ids properts

SimpleGetxController , it is simple of GetxController that just have update functonillty used ofr SimpleValue below

SimpleValue : it is take one value and wrrapes it around SimpleGetxController like(Value forGetxController) using getert and setter

notifier extensions : like 0.obs but for SimpleValue like that 0.notifier
__________________________________________________-
SimpleBuilder it is getx widget work very good with notifier and SimpleValue


with this we could do that

any dart file

        final count = 0.notifier;

then inside our widget

          SimpleBuilder(builder: (_) {
            return Text(count.value.toString());
          })

or

          GetBuilderC<SimpleValue<int>>(
              controller: count,
              builder: (count) {
                return Text(count.value.toString());
              })`
