def _build():
    shell("echo build")
    return done(
        outputs={
            "message": read("message.txt")
        }
    )

task(_build, "build")

def _approval(approve, message):
    return done(
        outputs={
            "message": message
        }
    )

task(
    _approval, 
    "approval",
    inputs={
        "approve": ref("./custom/approve"),
        "message": ref("./task/build#output/message")
    }
)
