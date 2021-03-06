package hello;

aspect Trace {
    pointcut atSayHello(): call(void HelloWorld.sayHello());

    before(): atSayHello() {
        System.out.println("[Before sayHello]");
    }

    after(): atSayHello() {
        System.out.println("[After sayHello]");
    }
}
