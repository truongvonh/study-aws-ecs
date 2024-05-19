import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello world codepipeline AWS new update pipeline #3';
  }
}
