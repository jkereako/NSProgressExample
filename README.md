# NSProgressExample
I've been fighting with NSProgress lately and so I decided to create an isolated project for testing NSProgress.

All of the files in the directory Fixtures were made with the special device, [`/dev/zero`](https://en.wikipedia.org/wiki//dev/zero) with this command:

```sh
dd if=/dev/zero of=1mb_test_file bs=1048576 count=1 
```
