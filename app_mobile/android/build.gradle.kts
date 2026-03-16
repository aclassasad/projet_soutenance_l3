buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Plugins Gradle en Kotlin DSL
        classpath("com.android.tools.build:gradle:8.2.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.21")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔹 Déplacer le dossier build global
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    configurations.all {
        resolutionStrategy {
            // 🔹 Forcer Gradle à utiliser une version stable
            force("com.android.tools.build:gradle:8.2.1")
        }
    }
}

subprojects {
    afterEvaluate { project ->
        if (project.hasProperty("android")) {
            project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                buildToolsVersion("30.0.3")
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
            if (project.hasProperty("kotlinOptions")) {
                project.extensions.configure<org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions>("kotlinOptions") {
                    jvmTarget = JavaVersion.VERSION_17.toString()
                }
            }
        }
    }
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}